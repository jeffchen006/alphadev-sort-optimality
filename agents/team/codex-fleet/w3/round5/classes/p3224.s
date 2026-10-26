# n=5 model=out iset=I1 prefix14_class=3224
cmp P0, P3
cmovge S2, P3
mov S0, P1
cmovge P3, P0
cmovle S2, P0
cmp P2, P1
cmovl P1, P2
cmovg S0, P2
mov P0, P1
cmp S2, P1
cmovge P0, S2
cmovg S2, P1
cmp S0, P3
cmovle P2, P3
