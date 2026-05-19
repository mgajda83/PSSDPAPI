Function Get-SDPRequest
{
	<#
	.SYNOPSIS
		Get request

	.PARAMETER RequestId
		Request id

	.PARAMETER InputData
		Custom search object.

list_info :
{
	"row_count"         : number of rows to be returned(maximum row_count = 100)
	"start_index"       : starting row index
	"sort_field"        : "fieldName"
	"sort_order"        : "asc/desc",
	"get_total_count"   : boolean (by default it will be false)
	"has_more_rows"     : boolean (will be returned with the response)
	"total_count"       : count (will be returned with the response only)
	"search_criteria"   :  Refer search criteria object given in the attributes of List Info(For performing advanced search)
	"fields_required"   : [ "list of fields required" ]
}

	.PARAMETER Limit
		Limit returned data. Default return last 100 items.

	.EXAMPLE
		$Request = Get-SDPRequest -RequestId 547

	.EXAMPLE
		557, 558 | Get-SDPRequest

	.EXAMPLE
		$InputData = @{
			"list_info"= @{
				"search_criteria"= @{
					"subject"= "SRS-F133"
					"status.name"= "Otwarte"
				}
			}
		}

		Get-SDPRequest -InputData $InputData

	.NOTES
		Author: Michal Gajda

	.LINK
		https://www.manageengine.com/products/service-desk/sdpod-v3-api/requests/request.html#get-list-request
		https://www.manageengine.com/products/service-desk/sdpod-v3-api/requests/request.html#get-request
		https://www.manageengine.com/products/service-desk/sdpod-v3-api/getting-started/input-data.html
		https://www.manageengine.com/products/service-desk/sdpod-v3-api/getting-started/search-criteria.html
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
		[Int]$RequestId,
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
		if($MyInvocation.BoundParameters.ContainsKey("RequestId"))
		{
			#Get by ID
			$InvokeParams = @{
				UriSDP = $UriSDP
				ApiKey = $ApiKey
				Method = "GET"
				EntityUri = "/api/v3/requests/$RequestId"
			}

			#Send request
			If ($PSCmdlet.ShouldProcess($RequestId,"Get request by id"))
			{
				$Result = Invoke-SDPAPIEntity @InvokeParams
				$Results = $Result.request
			}
		} else {
			#Get by Search
			$InvokeParams = @{
				UriSDP = $UriSDP
				ApiKey = $ApiKey
				Method = "GET"
				EntityUri = "/api/v3/requests"
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
			If ($PSCmdlet.ShouldProcess("Get request by search params"))
			{
				$Result = Invoke-SDPAPIEntity @InvokeParams
				$Results = $Result.requests
			}
		}

		#Return result
		if($MyInvocation.BoundParameters.ContainsKey("Debug"))
		{
			Return $Result
		} else {
			Write-Verbose ($Results | Measure-Object).Count
			Return $Results
		}
	}

	End{}
}
