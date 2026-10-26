# n=5 model=out iset=I1 prefix14_class=9767
mov S0, P0
cmp P1, S0
mov S1, P2
cmovle S0, P1
cmovl P1, P0
cmp P3, S1
cmovle S1, P3
cmovl P3, P2
cmp P1, P3
cmovg P0, P3
cmovge P3, P1
cmovg P1, P0
cmp S0, S1
cmovl S2, S0
