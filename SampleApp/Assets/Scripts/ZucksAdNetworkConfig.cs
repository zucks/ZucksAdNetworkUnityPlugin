using UnityEngine;
using System.Collections;

public class ZucksAdNetworkConfig : MonoBehaviour {

	void Awake () {
		ZucksAdNetworkPlugin.SetMediaId ("YOUR_MEDIA_ID");
	}

}
