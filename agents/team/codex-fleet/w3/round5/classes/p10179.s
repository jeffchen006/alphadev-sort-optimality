# n=5 model=out iset=I1 prefix14_class=10179
cmp P1, P0
cmovle S1, P1
mov S0, P2
cmovle P1, P0
cmovl P0, S1
cmp S0, P3
cmovge P2, P3
cmovge P3, S0
cmp P3, P1
mov S0, P3
cmovg P3, P1
cmovge P1, S0
mov P1, P3
cmp P2, P0
