# n=5 model=out iset=I1 prefix14_class=6395
cmp P0, P1
mov S2, P0
cmovg P0, P1
cmovg P1, S2
mov S0, P2
cmp P3, P2
cmovg S0, P3
cmovl P2, P3
cmovle P3, S0
cmp P1, P3
cmovge S0, P1
cmovle P3, P1
cmp P2, P0
cmovle S0, P2
