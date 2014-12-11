using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

// callback
public enum ZucksAdInterstitialViewCallbackType : int
{
	ZucksAdInterstitialShow = 0,
	ZucksAdInterstitialTap = 1,
	ZucksAdInterstitialClose = 2,
	ZucksAdInterstitialCancel = 3,
	ZucksAdInterstitialOffline = 4,
	ZucksAdInterstitialMediaIDError = 5,
	ZucksAdInterstitialNoConfig = 6,
	ZucksAdInterstitialSizeError = 7,
	ZucksAdInterstitialGetConfigError = 8,
	ZucksAdInterstitialOtherError = 100
}

public class ZucksAdNetworkInterstitial : MonoBehaviour {
	public static int MaxInterstitialObjectId;
	[HideInInspector]
	public int InterstitialObjectId;

	public string MediaId = "";

	// HexColor
	public string HexColor = "";

	// callback object id
	public static int cb_object_id;
	// callback value
	public static int cb_value;
	
	#if UNITY_ANDROID && !UNITY_EDITOR
	static AndroidJavaObject AndroidPlugin = null;
	#endif

	// FluctInterstitialView
	#if UNITY_IPHONE && !UNITY_EDITOR
	[DllImport ("__Internal")]
	private static extern void FluctInterstitialViewCreate(int object_id, string medea_id);
	[DllImport ("__Internal")]
	private static extern void FluctInterstitialViewDestroy(int object_id);
	[DllImport ("__Internal")]
	private static extern void FluctInterstitialViewExist(int object_id);
	[DllImport ("__Internal")]
	private static extern void FluctInterstitialViewSetMediaID(int object_id, string media_id);
	[DllImport ("__Internal")]
	private static extern void FluctInterstitialViewShow(int object_id, string hex_color);
	[DllImport ("__Internal")]
	private static extern void FluctInterstitialViewDismiss(int object_id);
	[DllImport ("__Internal")]
	private static extern void FluctInterstitialViewStartCallback(int object_id, string object_name);
	#elif UNITY_ANDROID && !UNITY_EDITOR
	private void FluctInterstitialViewCreate(string mediaId) {
		AndroidJavaObject activityContext;
		using (var actClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer")) {
			activityContext = actClass.GetStatic<AndroidJavaObject>("currentActivity");
		}
		AndroidPlugin.Call("FluctInterstitialViewCreate", activityContext, mediaId);
	}
	private void FluctInterstitialViewStartCallback(string cb_obj) {
		AndroidPlugin.Call("FluctInterstitialViewStartCallback", cb_obj);
	}
	private void FluctInterstitialViewShow(string hexColor) {
		AndroidPlugin.Call("FluctInterstitialViewShow", hexColor);
	}
	private void FluctInterstitialViewDestroy() {
		AndroidPlugin.Call("FluctInterstitialViewDestroy");
	}
	#else
	private void FluctInterstitialViewCreate(int object_id, string medea_id){ UnityEngine.Debug.Log("FluctInterstitialViewCreate()"); }
	private void FluctInterstitialViewDestroy(int object_id){ UnityEngine.Debug.Log("FluctInterstitialViewDestroy()"); }
	private void FluctInterstitialViewExist(int object_id){ UnityEngine.Debug.Log("FluctInterstitialViewExist()"); }
	private void FluctInterstitialViewSetMediaID(int object_id, string media_id){ UnityEngine.Debug.Log("FluctInterstitialViewSetMediaID()"); }
	private void FluctInterstitialViewShow(int object_id, string hex_color){ UnityEngine.Debug.Log("FluctInterstitialViewShow()"); }
	private void FluctInterstitialViewDismiss(int object_id){ UnityEngine.Debug.Log("FluctInterstitialViewDismiss()"); }
	private void FluctInterstitialViewStartCallback(int object_id, string object_name){ UnityEngine.Debug.Log("FluctInterstitialViewStartCallback()"); }
	#endif

	public void ShowInterstitial(string cb_obj, string media_id = null, string hex_color = null)
	{
		InterstitialObjectId = MaxInterstitialObjectId;
		MaxInterstitialObjectId++;

		string mid = string.IsNullOrEmpty(media_id) ? MediaId : media_id;
		string hc = string.IsNullOrEmpty(hex_color) ? HexColor : hex_color;

		#if UNITY_IPHONE && !UNITY_EDITOR
		FluctInterstitialViewCreate(InterstitialObjectId,mid);
		FluctInterstitialViewExist(InterstitialObjectId);
		FluctInterstitialViewSetMediaID(InterstitialObjectId,mid);
		FluctInterstitialViewStartCallback(InterstitialObjectId,cb_obj);
		FluctInterstitialViewShow(InterstitialObjectId,hc);
		#elif UNITY_ANDROID && !UNITY_EDITOR
		if (null == AndroidPlugin) {
			AndroidPlugin = new AndroidJavaObject( "com.voyagegroup.android.unity.plugins.FluctUnityPlugins");
		}
		FluctInterstitialViewCreate(mid);
		FluctInterstitialViewStartCallback(cb_obj);
		FluctInterstitialViewShow(hc);
		#else
		FluctInterstitialViewCreate(InterstitialObjectId,mid);
		FluctInterstitialViewExist(InterstitialObjectId);
		FluctInterstitialViewSetMediaID(InterstitialObjectId,mid);
		FluctInterstitialViewStartCallback(InterstitialObjectId,cb_obj);
		FluctInterstitialViewShow(InterstitialObjectId,hc);
		#endif
	}
	public void HideInterstitial()
	{
		#if UNITY_IPHONE && !UNITY_EDITOR
		FluctInterstitialViewExist(InterstitialObjectId);
		FluctInterstitialViewDismiss(InterstitialObjectId);
		FluctInterstitialViewDestroy(InterstitialObjectId);
		#elif UNITY_ANDROID && !UNITY_EDITOR
		FluctInterstitialViewDestroy();
		#else
		FluctInterstitialViewExist(InterstitialObjectId);
		FluctInterstitialViewDismiss(InterstitialObjectId);
		FluctInterstitialViewDestroy(InterstitialObjectId);
		#endif
	}

	// UnitySendMessage call method
	void CallbackValue (string message)
	{
		#if UNITY_IPHONE && !UNITY_EDITOR
		string[] arrMessage = message.Split(':');
		cb_object_id = int.Parse(arrMessage[0]);
		cb_value = int.Parse(arrMessage[1]);
		#elif UNITY_ANDROID && !UNITY_EDITOR
		cb_value = int.Parse(message);
		#else
		string[] arrMessage = message.Split(':');
		cb_object_id = int.Parse(arrMessage[0]);
		cb_value = int.Parse(arrMessage[1]);
		#endif
	}

	public int InterstitialCallback () {
		if (InterstitialObjectId == cb_object_id) {
			return cb_value;
		} else {
			return -1;
		}
	}


}
