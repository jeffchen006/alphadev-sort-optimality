# n=5 model=out iset=I1 prefix14_class=6232
mov S1, P0
mov S0, P1
cmp P0, P2
cmovle P0, P2
cmovg S1, P2
cmp P3, S0
cmovge P1, P3
cmovg P3, S0
cmp P0, P1
cmovge S0, P1
cmovg P1, P0
mov P1, S1
cmovg P0, S0
cmp P3, P1
