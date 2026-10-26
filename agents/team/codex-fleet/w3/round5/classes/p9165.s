# n=5 model=out iset=I1 prefix14_class=9165
cmp P3, P1
cmovle S0, P3
cmovg S0, P1
cmovge P1, P3
cmp P0, P2
cmovl P3, P2
cmovl P2, P0
cmovl P0, P3
cmp P2, S0
mov S1, P1
cmovge P3, P2
cmovg P2, S0
cmovge S0, P3
cmp P0, S1
