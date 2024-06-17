//
//  AiliaAudioPluginPreventStrip.c
//
//  Created by Kazuki Kyakuno on 2023/07/31.
//

// Dummy link to keep libailia_audio.a from being deleted

extern int ailiaAudioLog1p(void* dst, const void* src, int src_n);

void test(void){
    ailiaAudioLog1p(0, 0, 0);
}
