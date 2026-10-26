# n=5 model=out iset=I1 prefix14_class=2500
mov S1, P0
cmp P1, S1
cmovl P0, P1
cmovle P1, S1
mov S0, P2
cmp P3, P2
cmovg S0, P3
cmovg P3, P2
cmp P1, S0
mov S2, P1
cmovle S2, S0
cmovl S0, P1
cmp P3, P0
cmovge P1, P3
