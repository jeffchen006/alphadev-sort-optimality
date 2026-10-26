# n=5 model=out iset=I1 prefix14_class=11628
cmp P2, P3
cmovle S2, P2
cmovge S2, P3
cmovle P2, P3
cmp P0, P1
mov S0, P0
mov S1, P2
cmovge S0, P1
cmovge P1, P0
cmp P2, P1
cmovg S1, P1
cmovl P2, P1
cmp S2, S0
cmovge P2, S2
