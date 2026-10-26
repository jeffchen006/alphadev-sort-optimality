# n=5 model=out iset=I1 prefix14_class=468
cmp P0, P2
mov S1, P0
mov S0, P1
cmovle S1, P2
mov S2, S1
cmovl P2, P0
cmp P1, P3
cmovg P1, P3
cmovge P3, S0
cmp P1, P2
cmovle S0, P2
cmovl P2, P1
cmovle P1, S0
mov P2, P1
