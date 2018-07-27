hw4_1.m是這次的作業檔。(雖然是4_1不過兩題都寫在裡面了)

hw4_1.m用%%區分成了6個section。分別是三張圖片的第一題(feature matching)和第二題(ransac)各一個section。
(都有寫註解)。跑每張圖片的第二部分前都需要先跑過該圖片的第一部分。
每一張圖片的：
第一部份可以調的參數是magnif和threshold。
第二部分可以調的參數是k,t,d。
以上都寫在每一個section的最前面，助教可以自行更換參數測試。

跑每一張圖片的第二題時，會需要使用者自行點選單本書圖片中該本書的四個角落(需順時針或逆時針點選)。

第二題結果呈現的部分，藍色的線是inlier，綠色的線是outlier。
deviation vector的部分，正確特徵點位置會用紅色圓圈標記，transformed特徵點則是用綠色圓圈標記。deviation vector則是用quiver標記。

homography.m、clicker.m和largeDarkFigure.m依然是這次作業我會用到的輔助程式(助教的clicker範例真是百用不膩啊~~ <3 )