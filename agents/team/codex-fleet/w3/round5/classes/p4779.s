# n=5 model=out iset=I1 prefix14_class=4779
cmp P1, P2
mov S1, P1
cmovl P1, P2
cmovl P2, S1
mov S2, P0
cmp S2, P3
cmovl P0, P3
cmovge S2, P3
cmp S2, P2
cmovg S0, P2
cmovg P2, S2
cmovg S2, S0
mov S1, P0
mov S2, P2
