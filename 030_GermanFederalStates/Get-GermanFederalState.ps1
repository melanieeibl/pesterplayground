function Get-GermanFederalState ([string]$Name = '*') {
    $germanFederalStates = @(
        @{ Name = 'Baden-Württemberg'      }
        @{ Name = 'Bayern'                 }
        @{ Name = 'Berlin'                 }
        @{ Name = 'Brandenburg'            }
        @{ Name = 'Bremen'                 }
        @{ Name = 'Hamburg'                }
        @{ Name = 'Hessen'                 }
        @{ Name = 'Mecklenburg-Vorpommern' }
        @{ Name = 'Niedersachsen'          }
        @{ Name = 'Nordrhein-Westfalen'    }
        @{ Name = 'Rheinland-Pfalz'        }
        @{ Name = 'Saarland'               }
        @{ Name = 'Sachsen'                }
        @{ Name = 'Sachsen-Anhalt'         }
        @{ Name = 'Schleswig-Holstein'     }
        @{ Name = 'Thüringen'              }
        # @{ Name = 'Mallorca'   }
    ) | ForEach-Object { [PSCustomObject] $_ }

    $germanFederalStates | Where-Object { $_.Name -like $Name }
}