# n=5 model=out iset=I1 prefix14_class=6779
mov S0, P2
cmp S0, P0
mov S2, P1
cmovl P2, P0
cmovg S0, P0
cmp P3, P1
cmovge S2, P3
cmovg P3, P1
cmp S2, P2
cmovge P1, S2
cmovge S2, P2
mov P0, S0
cmovge P2, P1
cmp S0, P3
