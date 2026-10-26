# n=5 model=out iset=I1 prefix14_class=5049
mov S2, P0
cmp P3, S2
mov S0, P1
cmovg S2, P3
cmovl P0, P3
cmp P2, S0
cmovge P1, P2
cmovle S0, P2
cmp S0, P0
mov P2, P0
cmovge P0, S0
cmovl P2, S0
cmp P1, S2
cmovle P2, S2
