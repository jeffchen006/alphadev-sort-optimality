# n=5 model=out iset=I1 prefix14_class=214
mov S1, P1
mov S2, P3
cmp S2, P2
cmovl S2, P2
cmovl P2, P3
cmp S1, P0
cmovge P1, P0
mov S0, P1
cmovge P0, S1
cmp P1, P2
cmovle P1, P2
cmovle P2, S0
cmovle S0, P1
mov S1, P0
