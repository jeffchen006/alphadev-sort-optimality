# n=5 model=out iset=I1 prefix14_class=12779
mov S2, P2
cmp P2, P3
cmovg S2, P3
cmovg P3, P2
mov S0, P1
cmp P0, S0
cmovl S0, P0
mov S1, S2
cmovg P1, P0
cmp S1, S0
cmovge S1, S0
cmovge S0, S2
cmp P1, P3
cmovge P2, P3
