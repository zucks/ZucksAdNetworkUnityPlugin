using UnityEngine;
using System.Collections;

public class ZucksAdStartShowInterstitial : ZucksAdNetworkInterstitial {

	private int callback_value;

	void Start () {
		ShowInterstitial("ZucksAdStartShowInterstitial");
	}

	void OnGUI()
	{
		//callback取得
		callback_value = InterstitialCallback();

		if (callback_value >= 0) {
			switch(callback_value)
			{
		         	case (int)ZucksAdInterstitialViewCallbackType.ZucksAdInterstitialShow :
					GUI.Label(new Rect(0,0,640,100), "広告表示がされた際に通知されます。");
					break;
		        	case (int)ZucksAdInterstitialViewCallbackType.ZucksAdInterstitialTap :
					GUI.Label(new Rect(0,0,640,100), "広告がタップされた際に通知されます。");
					break;
		        	case (int)ZucksAdInterstitialViewCallbackType.ZucksAdInterstitialClose :
					GUI.Label(new Rect(0,0,640,100), "広告が閉じられた際に通知されます。");
					break;
			}
		}

	}

	void OnDestroy () {
		HideInterstitial();
	}
}
