# n=5 model=out iset=I1 prefix14_class=3417
mov S0, P1
cmp P1, P3
cmovl P1, P3
mov S1, P2
cmovl P3, S0
cmp P2, P0
cmovg P2, P0
cmovle S1, P0
cmp P2, P3
cmovle P0, P3
cmovl P3, P2
mov S0, P1
cmovge P0, P2
mov P3, P0
