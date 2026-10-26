# n=5 model=out iset=I1 prefix14_class=9779
cmp P1, P0
cmovle S2, P1
cmovg S2, P0
cmovl P1, P0
cmp P2, P3
cmovle P0, P2
cmovle P2, P3
cmovg P0, P3
cmovge P3, P2
cmp P3, P1
cmovl P2, P1
cmovg P3, P1
cmp S2, P0
cmovle P1, P0
