# n=5 model=out iset=I1 prefix14_class=4738
cmp P0, P2
mov S0, P0
cmovle P0, P2
cmovg S0, P2
cmp P1, P3
cmovge P2, P3
mov S2, S0
cmovg P3, P1
cmovge P1, P2
cmp P1, S2
cmovg S2, P1
cmovge P1, S0
mov P2, S2
mov P1, P3
