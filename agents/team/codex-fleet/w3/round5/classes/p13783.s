# n=5 model=out iset=I1 prefix14_class=13783
cmp P1, P2
cmovge S1, P1
cmovge P1, P2
mov S0, P0
cmovg P2, S1
cmp P0, P3
cmovg S0, P3
cmovg P3, P0
mov P0, P3
cmp P2, P3
cmovg P0, P2
cmovle P3, P2
cmp P1, S0
cmovle P0, S0
