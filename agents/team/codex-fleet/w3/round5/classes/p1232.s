# n=5 model=out iset=I1 prefix14_class=1232
cmp P0, P3
cmovle S1, P0
cmovle P0, P3
cmovl P3, S1
cmp P1, P2
mov S0, P1
cmovge P1, P2
cmovl S0, P2
cmp P0, S0
mov S1, P0
cmovg P0, S0
cmovg S0, S1
cmp P3, P1
cmovge S1, P3
