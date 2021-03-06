package validator

import (
	"encoding/base64"
	"regexp"
)

var emailRegex = regexp.MustCompile("^[a-zA-Z0-9.!#$%&'*+\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")

func IsInvalidEmail(email string) bool {
	return !emailRegex.MatchString(email)
}

func IsInvalidIcon(icon string) bool {
	_, err := base64.StdEncoding.DecodeString(icon)
	return err != nil
}
