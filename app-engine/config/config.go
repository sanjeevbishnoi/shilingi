package config

import (
	"fmt"
	"log"

	"github.com/iamolegga/enviper"
	"github.com/spf13/viper"
)

// Config retrieved from different configuration sources
type Config struct {
	DBType              string `mapstructure:"DB_TYPE"`
	DBURI               string `mapstructure:"DB_URI"`
	Port                string `mapstructure:"APP_PORT"`
	PlanetScaleDB       string `mapstructure:"PLANETSCALE_DB"`
	PlanetScaleHost     string `mapstructure:"PLANETSCALE_DB_HOST"`
	PlanetScaleUsername string `mapstructure:"PLANETSCALE_DB_USERNAME"`
	PlanetScalePassword string `mapstructure:"PLANETSCALE_DB_PASSWORD"`
	FirebasePrivKeyPath string `mapstructure:"FIREBASE_PRIV_KEY_PATH"`
}

// PlanetScaleURI returns a mysql connection string from planetscale variables
func (cfg Config) PlanetScaleURI() string {
	return fmt.Sprintf("%s:%s@tcp(%s)/%s",
		cfg.PlanetScaleUsername, cfg.PlanetScalePassword,
		cfg.PlanetScaleHost, cfg.PlanetScaleDB)
}

func setConfigDefaults(v *enviper.Enviper) {
	v.SetDefault("DB_TYPE", "sqlite3")
	v.SetDefault("DB_URI", "file:shilingi.db?mode=rwc&_fk=1&cache=shared")
}

// SetupConfig retrieves configs from the environment
func SetupConfig() Config {
	v := enviper.New(viper.New())
	v.AutomaticEnv()
	setConfigDefaults(v)
	cfg := Config{}
	log.Print(v.Unmarshal(&cfg))
	return cfg
}
