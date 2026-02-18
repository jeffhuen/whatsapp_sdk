defmodule WhatsApp.Calls.CallsService do
  @moduledoc """
  Use the **`/{Phone-Number-ID}/calls`** endpoint to initiate, manage, and terminate WhatsApp calls. This API allows businesses to handle voice calling functionality through the WhatsApp Business Platform.

  ## Prerequisites

  *   [User Access Token](https://developers.facebook.com/docs/facebook-login/access-tokens#usertokens) with **`whatsapp_business_messaging`** permission
  *   `phone-number-id` for your registered WhatsApp account
  *   Call request permission from the WhatsApp user

  ## Call Actions

  - **connect**: Initiate a new call
  - **pre_accept**: Pre-accept a call (prepare for accepting)
  - **accept**: Accept an incoming call
  - **reject**: Reject an incoming call
  - **terminate**: Terminate an active call

  ## Session Description Protocol (SDP)

  For actions that require audio/video negotiation (connect, accept), you must provide session information including:
  - `sdp_type`: Must be "offer" for connect action, "answer" for accept action
  - `sdp`: RFC 8866 compliant SDP information

  ## Error Handling

  Error code 138006 indicates lack of call request permission for the business number from the WhatsApp user.

  """

  @doc """
  Manage Calls

  Use this endpoint to initiate, accept, reject, or terminate WhatsApp calls.

  **For initiating or managing a call:**
  Send a POST request with the appropriate action (connect, pre_accept, accept, reject, terminate).

  **For terminating a call:**
  Send a POST request with action "terminate" and the call_id.

  **Note:** Response with error code 138006 indicates a lack of a call request permission for this business number from the WhatsApp user.


  ## Examples

  ### Accept Call

      %{
    "action" => "accept",
    "messaging_product" => "whatsapp",
    "session" => %{
      "sdp" => "v=0\no=- 3626166318745852955 2 IN IP4 127.0.0.1\ns=-\nt=0 0\na=group:BUNDLE 0\na=extmap-allow-mixed\na=msid-semantic: WMS d8b26053-4474-4eb7-b3c3-c93d6c8c9b2e\nm=audio 9 UDP/TLS/RTP/SAVPF 111 63 9 0 8 110 126\nc=IN IP4 0.0.0.0\na=rtcp:9 IN IP4 0.0.0.0\na=ice-ufrag:4g1c\na=ice-pwd:qY/Bb+jQzg5ICn6X4fhJQetk\na=ice-options:trickle\na=fingerprint:sha-256 35:47:24:24:9F:93:C4:3E:DB:37:7F:BB:ED:F8:20:B5:AD:AC:DC:35:C2:7D:67:EE:6C:35:54:DF:A6:00:5C:4A\na=setup:actpass\na=mid:0\na=extmap:1 urn:ietf:params:rtp-hdrext:ssrc-audio-level\na=extmap:2 http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time\na=extmap:3 http://www.ietf.org/id/draft-holmer-rmcat-transport-wide-cc-extensions-01\na=extmap:4 urn:ietf:params:rtp-hdrext:sdes:mid\na=sendrecv\na=msid:d8b26053-4474-4eb7-b3c3-c93d6c8c9b2e 5b4d3d96-ea9b-44a8-87e6-11a1ad21a3bc\na=rtcp-mux\na=rtpmap:111 opus/48000/2\na=rtcp-fb:111 transport-cc\na=fmtp:111 minptime=10;useinbandfec=1\na=rtpmap:63 red/48000/2\na=fmtp:63 111/111\na=rtpmap:9 G722/8000\na=rtpmap:0 PCMU/8000\na=rtpmap:8 PCMA/8000\na=rtpmap:110 telephone-event/48000\na=rtpmap:126 telephone-event/8000\na=ssrc:2220762577 cname:w/zwpg3jXNiTFTdZ\na=ssrc:2220762577 msid:d8b26053-4474-4eb7-b3c3-c93d6c8c9b2e 5b4d3d96-ea9b-44a8-87e6-11a1ad21a3bc\n",
      "sdp_type" => "answer"
    },
    "to" => "14085551234"
  }

  ### Connect Call

      %{
    "action" => "connect",
    "biz_opaque_callback_data" => "0fS5cePMok",
    "messaging_product" => "whatsapp",
    "session" => %{
      "sdp" => "v=0\no=- 3626166318745852955 2 IN IP4 127.0.0.1\ns=-\nt=0 0\na=group:BUNDLE 0\na=extmap-allow-mixed\na=msid-semantic: WMS d8b26053-4474-4eb7-b3c3-c93d6c8c9b2e\nm=audio 9 UDP/TLS/RTP/SAVPF 111 63 9 0 8 110 126\nc=IN IP4 0.0.0.0\na=rtcp:9 IN IP4 0.0.0.0\na=ice-ufrag:4g1c\na=ice-pwd:qY/Bb+jQzg5ICn6X4fhJQetk\na=ice-options:trickle\na=fingerprint:sha-256 35:47:24:24:9F:93:C4:3E:DB:37:7F:BB:ED:F8:20:B5:AD:AC:DC:35:C2:7D:67:EE:6C:35:54:DF:A6:00:5C:4A\na=setup:actpass\na=mid:0\na=extmap:1 urn:ietf:params:rtp-hdrext:ssrc-audio-level\na=extmap:2 http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time\na=extmap:3 http://www.ietf.org/id/draft-holmer-rmcat-transport-wide-cc-extensions-01\na=extmap:4 urn:ietf:params:rtp-hdrext:sdes:mid\na=sendrecv\na=msid:d8b26053-4474-4eb7-b3c3-c93d6c8c9b2e 5b4d3d96-ea9b-44a8-87e6-11a1ad21a3bc\na=rtcp-mux\na=rtpmap:111 opus/48000/2\na=rtcp-fb:111 transport-cc\na=fmtp:111 minptime=10;useinbandfec=1\na=rtpmap:63 red/48000/2\na=fmtp:63 111/111\na=rtpmap:9 G722/8000\na=rtpmap:0 PCMU/8000\na=rtpmap:8 PCMA/8000\na=rtpmap:110 telephone-event/48000\na=rtpmap:126 telephone-event/8000\na=ssrc:2220762577 cname:w/zwpg3jXNiTFTdZ\na=ssrc:2220762577 msid:d8b26053-4474-4eb7-b3c3-c93d6c8c9b2e 5b4d3d96-ea9b-44a8-87e6-11a1ad21a3bc\n",
      "sdp_type" => "offer"
    },
    "to" => "14085551234"
  }

  ### Reject Call

      %{
    "action" => "reject",
    "messaging_product" => "whatsapp",
    "to" => "14085551234"
  }

  ### Terminate Call

      %{
    "action" => "terminate",
    "call_id" => "wacid.HBgLMTIxODU1NTI4MjgVAgARGCAyODRQIAFRoA",
    "messaging_product" => "whatsapp"
  }
  """
  @spec manage_calls(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}
  def manage_calls(client, params, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    WhatsApp.Client.request(
      client,
      :post,
      "/#{client.api_version}/#{phone_number_id}/calls",
      [json: params] ++ opts
    )
  end
end
