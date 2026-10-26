# n=5 model=out iset=I1 prefix14_class=5099
mov S0, P0
cmp P0, P2
cmovge P0, P2
mov S1, P0
cmovle S0, P2
cmp P1, P3
cmovge S2, P1
cmovg P1, P3
cmovle S2, P3
cmp P0, P1
cmovle S1, P1
mov P2, S1
cmovl P1, P0
cmp S2, S0
