# n=5 model=out iset=I1 prefix14_class=1793
cmp P3, P1
cmovge S0, P1
cmovg P1, P3
cmovg P3, S0
cmp P0, P2
cmovge S0, P0
mov S1, P1
cmovg P0, P2
cmovle S0, P2
cmp P1, S0
cmovge S1, S0
cmovl P1, S0
mov S0, P3
cmp P0, P3
