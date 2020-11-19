package main

# XXX: A simple policy that should always be true
deny[msg] {
	not input.metadata.name
	msg := "Name missing"
}
