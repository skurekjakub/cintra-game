"""Bertha v7: critic round 2. Rows painted as (x, string) segments; later segments overwrite."""
import sys
from PIL import Image
PAL = {
 'O':'#321524','W':'#fff7e6','C':'#e6dcc4','a':'#bfb09c','q':'#968278',
 'h':'#fcac5c','H':'#e26c32','d':'#a83a28','D':'#561c28',
 's':'#ffd2a2','S':'#e89874','k':'#b05c62','b':'#f07e76','m':'#963a48',
 'G':'#3c8452','g':'#245440','n':'#182c2e','L':'#5aa066',
 'T':'#c08050','t':'#8a5030','r':'#5a3020',
}
W, H = 30, 32
R = {y: [] for y in range(H)}
def p(y, x, s): R[y].append((x, s))
# ---------- body ----------
p(14, 5, "OOOO"); p(14, 20, "OOOO")
p(15, 4, "OGGGGgqkkkkkkkkqngggnO")
p(16, 4, "OGGGnGaCCCCCCaaqngggnO")
p(17, 4, "OGGGnGCCCCgCCaaqngggnO")
p(18, 3, "O"+"GGG"+"n"+"GG"+"aCCCCCCaaq"+"n"+"ggn")
p(19, 3, "O"+"CCa"+"n"+"GG"+"aCCCgCCaqq"+"n"+"ggn")
p(20, 2, "O"+"sSk"+"n"+"GLLG"+"aaaaaaaq"+"g"+"n"+"g"+"sS")
p(21, 2, "O"+"SSk"+"n"+"LGGG"+"GGGGGggg"+"g"+"n"+"g"+"SS")
p(22, 2, "O"+"kkk"+"n"+"GGGG"+"GGGGGggg"+"g"+"n"+"g"+"kk")
p(23, 3, "OOOOtttGGGGGGGggtttOOO")
p(24, 5, "OGGGttttttttttrtgggnO")
p(25, 5, "OGGgCaaaaaqaaaaqgggnO")
p(26, 5, "OGGgCaaaaaqaaaqqggnnO")
p(27, 4, "OGGGgCaaaaaqaaqqqggnnnO")
p(28, 4, "OgGggCaaaaaqaqqqqggnnnO")
p(29, 4, "OOOOO"+"qq"+"OOOOOOOO"+"qq"+"OOOOOO")
p(30, 7, "OTttO.......OTttO")
p(31, 8, "rrr........rrr")
# ---------- mug (right hand at hip) ----------
p(18, 25, "OOOO")
p(19, 24, "OCCCaO")
p(20, 24, "STttrO")
p(21, 24, "krrrrO")
p(22, 24, "rTttrO")
p(23, 24, "OOOOOO")
# ---------- head ----------
p(0, 12, "OOOOOO")
p(1, 11, "OhhHHddO")
p(2, 9, "OOOHHHHdDOOO")
p(3, 8, "OWWWCCCCCCaqO")
p(4, 7, "OWCCCCCCCCCCaqO")
p(5, 7, "OCCCCCCCCCCCCqO")
p(6, 7, "OaaHdhhhHdHHaqO")
p(7, 7, "OhHHdhhHHdHHHHdO")
p(8, 7, "OhHHdsSSSSSSkHdO")
p(9, 7, "OhHSddSSSSddkHdO")
p(10, 7, "OhHSSOSSSSOSkHdO")
p(11, 7, "OhHsSOSSSSOSkHdO")
p(12, 6, "OHHdSbSSSSSSbkdHHO")
p(13, 5, "OHHdOSSSSmmSSSkOdHHO")
p(14, 5, "OddOOkkSSSSSkkOOddO")
def build():
    im = Image.new("RGBA", (W, H), (0, 0, 0, 0)); px = im.load()
    for y in range(H):
        for x0, s in R[y]:
            for i, ch in enumerate(s):
                if ch != '.':
                    c = PAL[ch].lstrip('#'); px[x0 + i, y] = tuple(int(c[j:j+2], 16) for j in (0, 2, 4)) + (255,)
    return im
if __name__ == "__main__":
    build().save(sys.argv[1])
