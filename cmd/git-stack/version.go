package main

import (
	"fmt"

	"github.com/spf13/cobra"
)

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Prints the CLI version",
	RunE: func(cmd *cobra.Command, args []string) error {
		fmt.Println("0.3.2")
		return nil
	},
}
