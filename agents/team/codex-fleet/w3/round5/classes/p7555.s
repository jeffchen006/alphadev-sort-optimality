# n=5 model=out iset=I1 prefix14_class=7555
mov S1, P0
mov S0, P1
cmp P3, P0
cmovge S1, P3
cmovle P0, P3
cmovg P3, P0
cmp P2, S0
cmovg P1, P2
cmovg P2, S0
cmp P3, P2
cmovle P3, P2
cmovle P2, P0
cmp P1, S1
cmovg P0, P3
