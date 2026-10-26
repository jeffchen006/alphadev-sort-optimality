# n=5 model=out iset=I1 prefix14_class=1961
cmp P2, P1
cmovl S1, P2
cmovge S1, P1
cmovle P2, P1
mov S0, P0
cmp P3, P0
cmovle P0, P3
cmovg S0, P3
cmovle P3, S0
cmp P2, P3
cmovle P3, P2
cmovg S0, P2
cmp P0, S1
cmovg P2, S1
