# n=5 model=out iset=I1 prefix14_class=4444
cmp P3, P1
cmovge S2, P1
cmovg P1, P3
cmovge P3, S2
mov S0, P0
cmp P0, P2
cmovle S0, P2
mov S1, S0
cmovle P2, P0
cmp S0, P1
cmovl S0, P1
cmovl P1, S1
mov S0, P1
mov S1, P3
