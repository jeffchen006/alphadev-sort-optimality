# n=5 model=out iset=I1 prefix14_class=12109
mov S0, P2
cmp P0, P3
cmovle S2, P0
cmovle P0, P3
cmovl P3, S2
cmp P1, S0
cmovle S0, P1
mov S1, P3
cmovle P1, P2
mov P2, P1
cmp S1, S0
cmovle S1, S0
cmovge P3, S0
mov P3, S1
