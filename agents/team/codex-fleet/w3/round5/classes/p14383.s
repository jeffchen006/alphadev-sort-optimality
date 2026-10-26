# n=5 model=out iset=I1 prefix14_class=14383
mov S0, P3
cmp P0, S0
cmovle S0, P0
cmovl P0, P3
cmp P1, P2
cmovg P3, P2
cmovg P2, P1
cmovle P3, P1
cmovge P1, P3
cmp P1, S0
cmovg P3, S0
cmovg S0, P1
cmp P0, P2
cmovl P3, P0
