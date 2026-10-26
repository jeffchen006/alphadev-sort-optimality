# n=5 model=out iset=I1 prefix14_class=14214
mov S1, P0
cmp P1, S1
cmovl P0, P1
cmovle P1, S1
cmp P2, P3
mov S0, P3
cmovg P3, P2
cmovge P2, S0
cmp P3, P1
cmovle S0, P1
mov S2, P2
cmovl P1, P3
cmovl P3, S0
mov S1, P1
