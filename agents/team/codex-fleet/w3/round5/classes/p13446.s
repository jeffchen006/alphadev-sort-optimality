# n=5 model=out iset=I1 prefix14_class=13446
cmp P0, P1
cmovg S2, P0
cmovge P0, P1
cmovg P1, S2
cmp P2, P3
mov S2, P3
cmovl P3, P2
cmovg S2, P2
cmp P3, P0
cmovle S0, P0
cmovl P0, P3
cmovle P3, S0
cmp P1, S2
cmovl S0, P1
