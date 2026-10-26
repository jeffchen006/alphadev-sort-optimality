# n=5 model=out iset=I1 prefix14_class=6245
mov S1, P1
cmp P3, P1
cmovge P1, P3
mov S0, P2
cmovg P3, S1
cmp P0, S0
cmovge P2, P0
cmovg P0, S0
cmp P1, P2
mov S1, P2
cmovge S1, P1
cmovg P1, P2
cmp P3, P0
cmovle P2, P1
