# n=5 model=out iset=I1 prefix14_class=2011
cmp P1, P3
cmovg S0, P3
cmovge P3, P1
cmovg P1, S0
mov S0, P2
cmp P2, P0
cmovg S0, P0
cmovle P2, P0
mov P0, P2
cmp P3, P2
cmovge P0, P3
cmovge P3, P2
mov P0, P3
cmp P1, S0
