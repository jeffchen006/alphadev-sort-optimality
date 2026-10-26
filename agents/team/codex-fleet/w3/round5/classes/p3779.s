# n=5 model=out iset=I1 prefix14_class=3779
mov S0, P3
cmp P3, P1
cmovg S0, P1
cmovge P1, P3
mov P3, P0
mov S1, S0
cmp P2, P0
cmovge P3, P2
cmovge P2, P0
cmp S1, P2
cmovle S0, P2
cmovl P2, S1
cmp P1, P3
cmovg P2, P3
