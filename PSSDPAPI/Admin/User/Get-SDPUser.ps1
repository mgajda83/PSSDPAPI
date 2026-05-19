Function Get-SDPUser
{
	<#
	.SYNOPSIS
		Get user

	.PARAMETER UserId
		User id

	.PARAMETER InputData
		Custom search object.

list_info :
{
	"row_count"         : number of rows to be returned(maximum row_count = 100)
	"start_index"       : starting row index
	"sort_field"        : "fieldName"
	"sort_order"        : “asc/desc”,
	"get_total_count"   : boolean (by default it will be false)
	"has_more_rows"     : boolean (will be returned with the response)
	"total_count"       : count (will be returned with the response only)
	"search_criteria"   :  Refer search criteria object given in the attributes of List Info(For performing advanced search)
	"fields_required" : [ "list of fields required" ]
}

	.PARAMETER Limit
		Limit returned data. Default return last 100 items.

	.EXAMPLE
		$Request = Get-SDPUser -UserId 547

	.EXAMPLE
		557, 558 | Get-SDPUser

	.EXAMPLE
		$InputData = @{
			"list_info"= @{
				"search_criteria"= @{
						field = "last_name"
						condition = "is"
						value = "Gajda"
				}
			}
		}

		Get-SDPUser -InputData $InputData

	.EXAMPLE
		$InputData = @{
					list_info = @{
						get_total_count = $true
						row_count = 10
						search_criteria = @{
							field = "account"
							condition = "is"
							value = @{
								id=1
							}
						}
					}
				}

		Get-SDPUser -InputData $InputData

	.NOTES
		Author: Michal Gajda

	.LINK
		https://ui.servicedeskplus.com/APIDocs3/index.html#get-an-user
	#>
	[CmdletBinding(
		SupportsShouldProcess=$True,
		ConfirmImpact="Low",
		DefaultParameterSetName="Search"
	)]
	param (
		[String]$UriSDP,
		[String]$ApiKey,
		[Parameter(ParameterSetName="ItemId",
			ValueFromPipeline)]
		[Int]$UserId,
		[Parameter(ParameterSetName="Search")]
		$InputData,
		[Parameter(ParameterSetName="Search")]
		[ValidateScript({$_ -is [int] -and $_ -gt 0})]
		$Limit = 100,
		[Parameter(ParameterSetName="Search")]
		[Switch]$All
	)

	Begin
	{
		#Create headers
		if(!$MyInvocation.BoundParameters.ContainsKey("UriSDP"))
		{
			if($Global:UriSDP)
			{
				$UriSDP = $Global:UriSDP
			} else {
				Write-Error "UriSDP parameter is required or run Set-SDPApiConnection first." -ErrorAction Stop
			}
		}
		if(!$MyInvocation.BoundParameters.ContainsKey("ApiKey"))
		{
			if($Global:ApiKey)
			{
				$ApiKey = $Global:ApiKey
			} else {
				Write-Error "ApiKey parameter is required or run Set-SDPApiConnection first." -ErrorAction Stop
			}
		}

		if($All) { $Limit = [int]::MaxValue }
	}

	Process
	{
		if($MyInvocation.BoundParameters.ContainsKey("UserId"))
		{
			#Get by ID
			$InvokeParams = @{
				UriSDP = $UriSDP
				ApiKey = $ApiKey
				Method = "GET"
				EntityUri = "/api/v3/users/$UserId"
			}

			#Send request
			If ($PSCmdlet.ShouldProcess($UserId,"Get user by id"))
			{
				$Result = Invoke-SDPAPIEntity @InvokeParams
				$Results = $Result.user
			}
		} else {
			#Get by Search
			$InvokeParams = @{
				UriSDP = $UriSDP
				ApiKey = $ApiKey
				Method = "GET"
				EntityUri = "/api/v3/users"
				Limit = $Limit
			}
			if($MyInvocation.BoundParameters.ContainsKey("InputData"))
			{
				$InvokeParams['InputData'] = $InputData
			} else {
				$InvokeParams['InputData'] = @{
					list_info = @{
						start_index = 1
						row_count = $Limit
						sort_field = "id"
						sort_order = "desc"
					}
				}
			}

			#Send request
			If ($PSCmdlet.ShouldProcess("Get users by search request"))
			{
				$Result = Invoke-SDPAPIEntity @InvokeParams
				$Results = $Result.users
			}
		}

		#Return result
		if($MyInvocation.BoundParameters.ContainsKey("Debug"))
		{
			Return $Result
		} else {
			Write-Verbose $Results.count
			Return $Results
		}
	}

	End{}
}
