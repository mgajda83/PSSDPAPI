Function Get-SDPRequestWorklog
{
	<#
	.SYNOPSIS
		Get Worklog data

	.PARAMETER RequestId
		Request id

	.PARAMETER WorklogId
		Worklog id

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
		$Worklogs = Get-SDPRequestWorklog -RequestId 54321

	.EXAMPLE
		$Worklog = Get-SDPRequestWorklog -RequestId 54321 -WorklogId 3315

	.NOTES
		Author: Michal Gajda

	.LINK
		https://www.manageengine.com/products/service-desk/sdpod-v3-api/requests/request_worklog.html
	#>
	[CmdletBinding(
		SupportsShouldProcess=$True,
		ConfirmImpact="Low",
		DefaultParameterSetName="Search"
	)]
	param (
		[String]$UriSDP,
		[String]$ApiKey,
		[Alias("Id")]
		[Parameter(Mandatory=$true,
			ValueFromPipeline)]
		[Int]$RequestId,
		[Parameter(ParameterSetName="ItemId")]
		[Int]$WorklogId,
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
		if($MyInvocation.BoundParameters.ContainsKey("WorklogId"))
		{
			#Get by ID
			$InvokeParams = @{
				UriSDP = $UriSDP
				ApiKey = $ApiKey
				Method = "GET"
				EntityUri = "/api/v3/requests/$RequestId/worklogs/$WorklogId"
			}

			#Send request
			If ($PSCmdlet.ShouldProcess($RequestId,"Get worklog $WorklogId from request id"))
			{
				$Result = Invoke-SDPAPIEntity @InvokeParams
				$Results = $Result.worklog
			}
		} else {
			#Get by Search
			$InvokeParams = @{
				UriSDP = $UriSDP
				ApiKey = $ApiKey
				Method = "GET"
				EntityUri = "/api/v3/requests/$RequestId/worklogs"
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
			If ($PSCmdlet.ShouldProcess($RequestId,"Get worklogs from request id"))
			{
				$Result = Invoke-SDPAPIEntity @InvokeParams
				$Results = $Result.worklogs
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
