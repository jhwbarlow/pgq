package pgq

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestAfter(t *testing.T) {
	j := &Job{}
	when := time.Now().Add(time.Minute)
	After(when)(j)
	assert.Equal(t, when, j.RunAfter)
}

func TestRetryWaits(t *testing.T) {
	j := &Job{}
	waits := []time.Duration{time.Minute, time.Minute * 60}
	RetryWaits(waits)(j)
	assert.Equal(t, Durations(waits), j.RetryWaits)
}

func TestRetryForever(t *testing.T) {
	j := &Job{}
	RetryForever(true, time.Minute)(j)
	assert.Equal(t, true, j.RetryForever)
	assert.Equal(t, Durations{time.Minute}, j.RetryWaits)
}
