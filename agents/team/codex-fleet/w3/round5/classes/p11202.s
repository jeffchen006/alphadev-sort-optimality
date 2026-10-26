# n=5 model=out iset=I1 prefix14_class=11202
cmp P3, P2
mov S2, P2
cmovg S2, P3
cmovge P3, P2
cmp P1, P0
mov S0, P1
cmovg S0, P0
cmovle P1, P0
cmp P1, S2
cmovg P0, P1
cmovg P1, S2
mov P2, S0
cmovg S2, P0
cmp P3, P2
