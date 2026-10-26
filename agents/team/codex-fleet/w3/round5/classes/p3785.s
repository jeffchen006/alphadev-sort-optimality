# n=5 model=out iset=I1 prefix14_class=3785
cmp P3, P1
mov S0, P3
cmovg S0, P1
cmovge P1, P3
cmp P2, P0
mov P3, P0
cmovge P3, P2
mov S1, S0
cmovge P2, P0
cmp S0, P2
cmovle S0, P2
cmovle P2, S1
cmp P1, P3
cmovle P2, P1
