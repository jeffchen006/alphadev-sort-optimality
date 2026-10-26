# n=5 model=out iset=I1 prefix14_class=4562
cmp P2, P0
cmovg S0, P0
mov S1, P3
cmovg P0, P2
cmovle S0, P2
cmp P1, P3
cmovge S1, P1
cmovge P1, P3
cmp P0, S1
cmovle P3, S1
cmovl S1, P0
cmovg P3, P0
cmp P1, S0
cmovg P0, P1
