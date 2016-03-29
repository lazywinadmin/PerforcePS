Function Test-PerforceUserExist
{
<#
	.SYNOPSIS
		Function to test if a user exists in Perforce
	
	.DESCRIPTION
		Function to test if a user exists in Perforce
	
	.PARAMETER UserName
		Specifies the username(s) to retrieve.
	
	.EXAMPLE
		PS C:\> Test-PerforceUserExist -UserName "fxcat"
	
	.EXAMPLE
		PS C:\> Test-PerforceUserExist -UserName "fxcat","Bob"
	
	.EXAMPLE
		PS C:\> Get-Content Users.txt | Test-PerforceUserExist
	
	.NOTES
		Francois-Xavier Cat
		lazywinadmin.com
		@lazywinadm
		github.com/lazywinadmin
#>
	PARAM (
		[Parameter(ValueFromPipeline)]
		[String[]]$UserName
	)
	PROCESS
	{
		FOREACH ($User in $UserName)
		{
			TRY
			{
				# Retrieve User
				$CheckAccount = p4 users $User
				
				if ($CheckAccount -like "*accessed*")
				{
					# Split en whitespace
					$CheckAccount = $CheckAccount -split '\s'
					
					# Prepare Output
					$Properties = @{
						"UserName" = $CheckAccount[0]
						"Email" = $CheckAccount[1] -replace "<|>", ""
						"PerforceAccount" = $CheckAccount[2] -replace "\(|\)", ""
					}
					
					# Output Information
					New-Object -TypeName PSObject -Property $Properties
				}
			}
			CATCH
			{
				Write-Error -Message "[Test-PerforceUserExist][PROCESS] Issue while retrieving the user"
				$Error[0].Exception.Message
			}
		}
	}
}