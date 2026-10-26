# n=5 model=out iset=I1 prefix14_class=9861
cmp P2, P1
mov S2, P1
cmovle S2, P2
cmovg P1, P2
mov S0, P1
cmp P0, P3
cmovge S1, P3
cmovge P3, P0
cmovg P0, S1
cmp P3, P1
cmovl P1, P3
cmovl P3, S0
cmp P0, S2
mov P3, P1
