# n=5 model=out iset=I1 prefix14_class=9709
mov S0, P2
mov S1, P3
cmp P0, P2
cmovge S0, P0
cmovg P0, P2
cmp P1, S1
cmovge P3, P1
cmovg P1, S1
cmp P3, S0
cmovle S1, S0
cmovle S0, P3
cmovl P3, S1
cmp P1, P0
cmovle P3, P1
