# n=5 model=out iset=I1 prefix14_class=7179
mov S0, P0
mov S1, P3
cmp P1, S1
cmovge P3, P1
cmovg P1, S1
cmp P2, S0
cmovle S0, P2
cmovle P2, P0
mov S2, P1
cmp P1, S0
cmovg S2, S0
cmovl P1, S0
cmp P2, P3
cmovge S0, P3
