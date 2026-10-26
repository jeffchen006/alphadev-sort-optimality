# n=5 model=out iset=I1 prefix14_class=2355
cmp P3, P0
mov S1, P2
cmovle S0, P3
cmovl P3, P0
cmovle P0, S0
cmp P2, P1
cmovl S1, P1
cmovge P2, P1
cmp P3, S1
cmovle S0, S1
cmovg S0, P3
cmovle S1, P3
cmp P2, P0
cmovg P3, P2
